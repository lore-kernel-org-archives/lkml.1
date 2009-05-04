Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbZEDQsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbZEDQsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbZEDQsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:48:40 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:46066 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbZEDQsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:48:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ByLP6I+heFzu90p/rx/fG2+zKPRrSJ7iN0hvJMWFZ0wcqKj2H5JHz8BRcAejcwhVqv
         OUBbb5clVhLeTyq0XQ/+XnJ8nPlBRWYkPUKIctQU08j6vNw5vLSHft1aWQBtqsGkEVEu
         ROxsvLJILSK32XdChP5V4HdXIvj6ojrw9lAQg=
MIME-Version: 1.0
In-Reply-To: <49FEA127.1000905@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
	 <49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>
	 <49FA0349.3090706@garzik.org>
	 <e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>
	 <49FEA127.1000905@kernel.org>
Date: Mon, 4 May 2009 09:48:37 -0700
Message-ID: <e9c3a7c20905040948m572e23dj1aa197dbd20ff037@mail.gmail.com>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
From: Dan Williams <dan.j.williams@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       Mauelshagen@redhat.com, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 4, 2009 at 1:02 AM, Tejun Heo <tj@kernel.org> wrote:
>> Couldn't the "fix" also just be a note to users to disable ignore_hpa
>> if they notice that there raid arrays are not assembling correctly?
>
> I don't know.  If it doesn't work automatically, the solution really
> isn't worth much.  People generally don't (shouldn't need to) have any
> idea what HPA is.  It basically boils down to "Linux doesn't support
> RAID".  :-)
>
> Maybe we should just put this issue to the rest and strongly advise
> people against BIOS raids.

That's a bit too far :-).  The real issue is that Linux is ignoring a
property of the platform.  To me ignoring HPA is like ignoring an e820
reserved memory region.  You might be able to get away with it
sometimes, but other times it breaks.

However, in the end I think having 'alt_size' available is a useful
mechanism for discovering and handling the ignore_hpa=1 case.   The
policy about when to trust it can be left to userspace.

Thanks,
Dan
