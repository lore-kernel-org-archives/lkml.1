Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbYHTQMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbYHTQMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbYHTQMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:12:30 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:35000 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbYHTQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xcqUZYcQZwKHj9qjf0sdK2f6/x9MM4JssATDrd/Do8caSjn4KIHx5KY3QM3WuNcfrl
         5r3Nbj3MO25EObTWV2J/sJ9MIBgGvr7Hz3u03peiUkYyGxifQnj7o+35XJ9BB1JHKrQg
         QCX0ks2IvEzsWJ3jBKMJYK1CNkkXFZziw6Kn8=
Message-ID: <19f34abd0808200912y3f9cd132hee6cd7ea9852d112@mail.gmail.com>
Date: Wed, 20 Aug 2008 18:12:28 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "the arch/x86 maintainers" <x86@kernel.org>
Subject: Re: latest -git: BUG: unable to handle kernel paging request (numaq_tsc_disable)
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0808200840v17a8e5d4ge60c332f864abd81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808200828o6496cbeap75b7242845e96ef3@mail.gmail.com>
	 <19f34abd0808200840v17a8e5d4ge60c332f864abd81@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 5:40 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Wed, Aug 20, 2008 at 5:28 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> Hi,
>>
>> This actually hardlocked my machine and I had to add an extra patch to
>> get any output at all. Base version is latest git, commit
>> 1fca25427482387689fa27594c992a961d98768f.
>>
>
> ...
>
>> Booting processor 1/1 ip 6000
>> <1>BUG: unable to handle kernel paging request at c08a45f0
>> <1>IP: [<c08a45f0>] numaq_tsc_disable+0x0/0x40
>> <0> [<c0678676>] ? init_intel+0x196/0x360
>
> Seems to be a section mismatch; init_intel() is __cpuinit while
> numaq_tsc_disable() is __init. Seems to be introduced in:
>
> commit 64898a8bad8c94ad7a4bd5cc86b66edfbb081f4a
> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> Date:   Sat Jul 19 18:01:16 2008 -0700
>
>    x86: extend and use x86_quirks to clean up NUMAQ code

Oops, I am wrong about numaq_tsc_disable() being __init. Still, I
believe that Yinghai might be able to say what's really wrong :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
