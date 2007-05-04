Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbXEDImB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbXEDImB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754604AbXEDImB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:42:01 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:32483 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbXEDIl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:41:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=S/rph092rSkMMaS8yheUBAyCrp9SNlL1cxWBPxSm9xTDTd2+0V7Jz0vxG8JOhKyyTBoqMLWiDUBzLtP4P6uqkaWVBbCE6fi81c8VonB7l7KpgLpry5UgQk4oM/ScPSsV8Bo0vHthda4nuRBj5pTA8gpvVoTRqIMNJrP/H5KaGoI=
Message-ID: <463AF1C5.4090401@gmail.com>
Date: Fri, 04 May 2007 10:41:41 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Frank van Maarseveen <frankvm@frankvm.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mark Lord <lkml@rtr.ca>, linux-scsi <linux-scsi@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       bzolnier@gmail.com,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: libata /dev/scd0 problem: mount after burn fails without eject
References: <20070501135951.GA17072@janus> <46374C11.1010702@rtr.ca> <6bffcb0e0705010731v44cfad1awf4342121245f7ab3@mail.gmail.com> <463AEBE0.7010506@gmail.com> <20070504083735.GA20072@janus>
In-Reply-To: <20070504083735.GA20072@janus>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Frank van Maarseveen wrote:
> On Fri, May 04, 2007 at 10:16:32AM +0200, Tejun Heo wrote:
>> Michal Piotrowski wrote:
>>> On 01/05/07, Mark Lord <lkml@rtr.ca> wrote:
>>>> Forwarding to linux-scsi and linux-ide mailing lists.
>>>>
>>>> Frank van Maarseveen wrote:
>>>>> Tested on 2.6.20.6 and 2.6.21.1
>>>>>
>>>>> I decided to swich from the old IDE drivers to libata and now there
>>>>> seems to be a little but annoying problem: cannot mount an ISO image
>>>>> after burning it.
>>>>>
>>>>> May  1 14:32:55 kernel: attempt to access beyond end of device
>>>>> May  1 14:32:55 kernel: sr0: rw=0, want=68, limit=4
>>>>> May  1 14:32:55 kernel: isofs_fill_super: bread failed, dev=sr0,
>>>> iso_blknum=16, block=16
>>>>> an "eject" command seems to fix the state of the PATA DVD writer
>>>>> or driver. The problem occurs for burning a CD and for DVD too with
>>>>> identical error messages.
>> Right after burning, if you run 'fuser -v /dev/sr0', what does it say?
> 
> Tried the fuser as root to be sure but it didn't show anything.

I guess sr is forgetting to set media changed flag somewhere.  Don't
really know where tho.  CC'd Bartlomiej, linux-scsi and linux-ide.  Any
ideas?

-- 
tejun
