Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbZDWUkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbZDWUkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 16:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZDWUkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 16:40:19 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48662 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181AbZDWUkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 16:40:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rWCUioC3khTI5eUqB4D8RxXobwP2jbRadz3YsKesEQQpl5Zeo0gLj53wmkOD7V+EHN
         whxtHJ5MQgSkzr1632p9MtWff0TZFmMuNdnk/aX1ZUye6aRpcmOiG3j+rojQtV5HJxVp
         sxogT7nJEA66fKdIRVFz4n43hpCgSb6bTNwdc=
Message-ID: <49F0D22E.6050101@gmail.com>
Date: Thu, 23 Apr 2009 22:40:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.3 Thunderbird/3.0b2
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, e1000-devel@lists.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [E1000-devel] e1000: "eeprom checksum is not valid" after kexec
References: <49F06EEB.9060500@gmail.com> <20090423141026.GB4046@vespa.holoscopio.com> <49F07B69.1020305@gmail.com> <20090423144145.GA3749@vespa.holoscopio.com>
In-Reply-To: <20090423144145.GA3749@vespa.holoscopio.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2009 04:41 PM, Thadeu Lima de Souza Cascardo wrote:
> On Thu, Apr 23, 2009 at 04:30:01PM +0200, Jiri Slaby wrote:
>> On 04/23/2009 04:10 PM, Thadeu Lima de Souza Cascardo wrote:
>>> Have you tried b43fcd7dc7b, found in v2.6.30-rc3?
>> I've tried 2.6.30-rc3-next-20090423 without success.
> 
> You mean next-20090423. The patch is really found there.
> 
> But, then, I realize you mean reverting these patches for the kernel
> that is running or the kernel that is being kexec'd?

The latter.

> If b43fcd7dc7b is applied to the running kernel, it fixes the shutdown
> issue, and the next loaded kernel probes e1000 fine.

Makes sense.

> If you are reverting 4a865905f in the kexec'd kernel and the running
> kernel does not have b43fcd7dc7b, then I'd like to test the revert for
> my case here, which is e100.

To make things clear: on that machine, there was stock opensuse 11.1
distro kernel which is 2.6.27-based (no b43fcd7dc7b). I needed to debug
a wireless bug, so I kexec'ed wireless-testing (contains 4a865905f already).

So in fact, 4a865905f from the testing kernel triggered a bug fixed in
near past by b43fcd7dc7b.

Did the other two e100* drivers suffer from the same and were fixed
recently? It would render kexec pretty unusable from the older kernels
if this is not going to be fixed anyhow :(.
