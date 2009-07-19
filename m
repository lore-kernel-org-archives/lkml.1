Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbZGSQWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbZGSQWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 12:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZGSQWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 12:22:41 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:43814 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbZGSQWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 12:22:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xLNiXn+pqEnxJoxIDSs7IiBYXyrI3Kw18h78I2+Ls8vMwAdUnwE2rLKt/LpG/XtgLO
         DAu8A7X2U14NF7fAPHsxVGlEmzdRcRlRRngDOgxXhKXGt4BQerpI6YE+YnOnGt5Na9wN
         V/Heqp0XQqCynULt80FuKJwt+fS6SrO9OEq5U=
MIME-Version: 1.0
In-Reply-To: <4A633542.8030502@tlinx.org>
References: <4A633542.8030502@tlinx.org>
Date: Sun, 19 Jul 2009 17:22:37 +0100
Message-ID: <9b2b86520907190922wb4f809dr5a315155211d6744@mail.gmail.com>
Subject: Re: disk Partition label changes and reflecting them in 
	/dev/disks-by-label/
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/19/09, Linda Walsh <lkml@tlinx.org> wrote:
>
>
> If I have a disk with no mounted partitions and I change the partition
> order,
> the OS will re-read the new partition and life goes on.
>
> However, if I create or change a new disk label, it seems label programs
> (and users) should have an option to reread the labels after the
> modification.
>
> Ideally any prog that changes a Label or UUID would trigger an update
> of what's in /dev/disks to reflect the new 'reality'.
>
> Currently, I go through through a seemingly bizarre ritual of invoking
> unmounting all other partitions on the same disk, then becoming root,
> running fdisk on the disk, then just exiting with "w".  This triggers
> a reread of not only the partition table, but also the new labels.
>
> However, I find this far less than ideal.  Is there a better way, or could
> there be a better way to update new Labels and UUID's that are actually
> on a disk -- perhaps even as an ordinary user command (since it would be
> a read-only operation on the disk that simply updates /dev/disk to reflect
> what's really there -- Especially being able to change only the label (or
> UUID), only on one partition w/o having to actually unmount other file
> systems
> on the disk....?
>
> Already implemented?  Or doable?  Or bad idea?
>
> Thanks,
> -linda

Already implemented :-).

The latest version of udev listens for inotify events on block
devices.  When a utility writes to the block device (or rather, when
it closes it after opening it for writing), Udev will synthesize a
"change" event.  The standard udev rules will re-check the device, and
update the links under /dev/disk to reflect changes in labels etc.

Alan
