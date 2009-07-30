Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbZG3Qxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbZG3Qxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 12:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZG3Qxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 12:53:32 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:63512 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZG3Qxb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=x/i/l1LiPLK5s06C+UPXaoctqhZknbEDCu8fB2lT8Z+sl/Ci1W5R2D2ePBc+p7B7vq
         IMA02cMuNyCK0ieT+PpAzAiekpgnu02u5XzWZPiic1+ywwMyzqvg84zUfgHMLikFWM+h
         CsEoKHd0alNUS/8N1k82NIP8NbuHCj9JwSgYg=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <200907301840.50894.arnd@arndb.de>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <1248963211.6391.45.camel@twins>
	 <7c86c4470907300917s5d3f2bf0iefe333cefc08c7fa@mail.gmail.com>
	 <200907301840.50894.arnd@arndb.de>
Date: Thu, 30 Jul 2009 18:53:30 +0200
Message-ID: <7c86c4470907300953g255c6088t7caaa1188be164e3@mail.gmail.com>
Subject: Re: I.1 - System calls - ioctl
From: stephane eranian <eranian@googlemail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 6:40 PM, Arnd Bergmann<arnd@arndb.de> wrote:
> On Thursday 30 July 2009, stephane eranian wrote:
>> long sys_perf_counter_open(
>>        struct perf_counter_attr *attr,
>>        enum perf_target_type  target_type,
>>        int target_id,
>>        int group_fd,
>>        unsigned long flags);
>>
>> Which is what you had, except without the struct.
>>
>> Then, it boils down to whether expressing a target id in 32 bits is enough.
>> Obviously, 64-bit would be the safest but then I understand this causes issues
>> on 32-bit systems.
>
> Just make it an unsigned long then, that still covers all cases
> where you only need the 64-bit type on 64-bit systems.
>
But that won't always work in the case of a 32-bit monitoring tool
running on top of
a 64-bit OS. Imagine the target id is indeed 64-bit, e.g., inode
number (as suggested
by Peter). It's not because you are a 32-bit tool than you cannot name
a monitoring
resource in a 64-bit OS.



>        Arnd <><
>
