Return-Path: <linux-kernel-owner+w=401wt.eu-S1759879AbYGPKeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879AbYGPKeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 06:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871AbYGPKeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 06:34:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:62332 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbYGPKeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 06:34:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M6vETGLsdLeL/KEEzSm1f5bkO8KW2rKwpILyGLZSkQ/K0IoeIiHzR5odPpxx5jveKj
         8Q274C0meWYyPNk1s/VNu1lhSBuuBckuIuzH6d4zaFfPhgwHVQDAaqJtJExwDVwyFZ51
         zklT2d2MByw+BdPhUXWessdx2FUcR2L+TxEVQ=
Message-ID: <520f0cf10807160334y7228527ev7e970b00c734778d@mail.gmail.com>
Date: Wed, 16 Jul 2008 12:34:23 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Andy Whitcroft" <apw@shadowen.org>
Subject: Re: Make the git URL match usage
Cc: "Jan Engelhardt" <jengelh@medozas.de>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080716102104.GA7477@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807161047.21040.jkacur@gmail.com>
	 <20080716102104.GA7477@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 12:21 PM, Andy Whitcroft <apw@shadowen.org> wrote:
> On Wed, Jul 16, 2008 at 10:47:20AM +0200, jkacur wrote:
>> On Wed, Jul 16, 2008 at 10:29 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>> >
>> > On Wednesday 2008-07-16 09:19, jkacur wrote:
>> >
>> >>Change the MAINTAINERS file so that the git URL reads EXACTLY the way someone
>> >>would use it.
>> >
>> >>-T:    git kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
>> >>+T:    git://git.kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
>> >
>> > I would not use it that^ way.
>> >
>> > -git://git.kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
>> > +git://git.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
>> >
>>
>> Yikes! Good catch, thank you, I've respun the patch below.
>>
>> Subject: Make the git URL match the usage
>> Change the MAINTAINERS file so that the git URL reads EXACTLY the way someone
>> would use it. They should only have to copy and paste it and not guess how
>> to modify it. Secondly, drop the "git" type when the protocol is already git://
>>
>> Signed-off-by:John Kacur <jkacur at gmail dot com>
>>
>> Index: linux-2.6.26/MAINTAINERS
>> ===================================================================
>> --- linux-2.6.26.orig/MAINTAINERS
>> +++ linux-2.6.26/MAINTAINERS
>> @@ -154,7 +154,7 @@ P:        Latchesar Ionkov
>>  M:   lucho@ionkov.net
>>  L:   v9fs-developer@lists.sourceforge.net
>>  W:   http://swik.net/v9fs
>> -T:   git kernel.org:/pub/scm/linux/kernel/ericvh/v9fs.git
>> +T:   git://git.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
>>  S:   Maintained
>
> This now looses information.  Although it is obvious that this particular
> example (after conversion) is a git repository over git protocol this falls
> down for other forms, for example a git repository exported over http://
> would appear as below:
>
>    T: http://www.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
>
> which would be indistiguishable from a quilt series such as Greg KH's
> which, if I follow your scheme logically ie. convert it to the same form,
> would also be represented as below:
>
>    T: http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
>
> I think your conversion makes sense in that the URL part should be
> exactly what one would use with the tool but you still need the tool
> designator:
>
>    T: git git://git.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
>    T: git http://www.kernel.org/pub/scm/linux/kernel/ericvh/v9fs.git
>    T: guilt http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
>
> -apw
>

Hi Andy, I only dropped the "git" designator in cases where the URL
protocol was git:// as in git://git.kernel.org
I believe there is no ambiguity there. I did not touch the designator
for something like quilt where http: is ambiguous.
I could leave the git designator in but I don't think it adds any
information, and it makes the line longer, and I'd rather avoid any
line wrap.
