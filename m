Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYHKOTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYHKOTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYHKOTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:19:01 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:48698 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYHKOTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:19:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eK42pUV7KWek5/YJqLm1XdD6RUjQmS5CQeXXvzhZuQu632OmL3yh9XW0dJ8pjmClqK
         Qrp57Mn18Yl+axn8q1usFpUgMCEDzO371BWl6AfDsEAI0mD//5Zj4ZsEuJsgjcrY61Zp
         rompGx3BhEDHd/OIT1vUmXTynsSbY4b8YAzFA=
Message-ID: <5d6222a80808110718i6a600858v7bdb5e08054ebefa@mail.gmail.com>
Date: Mon, 11 Aug 2008 11:18:58 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Gerd Hoffmann" <kraxel@redhat.com>
Subject: Re: Use of barriers in pvclock ABI
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, "Avi Kivity" <avi@qumranet.com>,
       "Marcelo Tosatti" <mtosatti@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
In-Reply-To: <489FE56E.1080707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <489CA3DA.1090400@goop.org> <489FE56E.1080707@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 4:08 AM, Gerd Hoffmann <kraxel@redhat.com> wrote:
>  Hi,
>
>> However, the pvclock_clocksource_read() implementation is
>> over-engineered, because it checks for an odd version and uses very
>> strong rmb() barriers (which generates either an "lfence" or "lock add
>> $0, (%esp)").
>>
>> If we're happy to guarantee as an ABI issue that the record will never
>> be updated cross-cpu, then we can make the barriers simply barrier() and
>> just check for (src->version != dst->version).
>>
>> Is that OK with you, or do you want to leave open the possibility of
>> doing cross-cpu time updates?
>
> Due to the TSC being involved here I don't expect cross-cpu time updates
> will ever happen.  IMHO it is fine to change that.

Okay for guest vcpu, but what about physical cpus?

IIRC, the checks are there, and so strict, to account for the
possiblity of the vcpu to be migrated to another cpu in the middle of
the
clock reading.
>
> cheers,
>  Gerd
>
> --
> http://kraxel.fedorapeople.org/xenner/
>



-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
