Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbZDGMX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbZDGMX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZDGMXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:23:18 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:63319 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZDGMXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Qu7rH5LNWaPTI3oc+y2TQlG13nVl7sW2BTNY9IdpeI4EhJ7QSMdtp5y58MSJKv83Z2
         Gxa6VMxfxhKAMFMLSipPylwlSmw1bcv1jr/rnkOv2uXX7Cy5Emp13fXfzpD/6xjyrTnV
         HAVEbtc1ibJ6XmaDFXRfULI4CytVJ9gndWyHw=
MIME-Version: 1.0
In-Reply-To: <1238431643-19433-1-git-send-email-philipp.reisner@linbit.com>
References: <1238431643-19433-1-git-send-email-philipp.reisner@linbit.com>
Date: Tue, 7 Apr 2009 17:53:14 +0530
Message-ID: <807b3a220904070523t746ad2abx6a46d30e816eb1d6@mail.gmail.com>
Subject: Re: [PATCH 00/12] DRBD: a block device for HA clusters
From: Nikanth K <nikanth@gmail.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, jens.axboe@oracle.com,
       nab@risingtidestorage.com, andi@firstfloor.org,
       Nikanth Karthikesan <knikanth@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On Mon, Mar 30, 2009 at 10:17 PM, Philipp Reisner
<philipp.reisner@linbit.com> wrote:
> Hi,
>
>  This is a repost of DRBD, to keep you updated about the ongoing
>  cleanups.
>
> Description
>
>  DRBD is a shared-nothing, synchronously replicated block device. It
>  is designed to serve as a building block for high availability
>  clusters and in this context, is a "drop-in" replacement for shared
>  storage. Simplistically, you could see it as a network RAID 1.
>
>  Each minor device has a role, which can be 'primary' or 'secondary'.
>  On the node with the primary device the application is supposed to
>  run and to access the device (/dev/drbdX). Every write is sent to
>  the local 'lower level block device' and, across the network, to the
>  node with the device in 'secondary' state.  The secondary device
>  simply writes the data to its lower level block device.
>
>  DRBD can also be used in dual-Primary mode (device writable on both
>  nodes), which means it can exhibit shared disk semantics in a
>  shared-nothing cluster.  Needless to say, on top of dual-Primary
>  DRBD utilizing a cluster file system is necessary to maintain for
>  cache coherency.
>
>  This is one of the areas where DRBD differs notably from RAID1 (say
>  md) stacked on top of NBD or iSCSI. DRBD solves the issue of
>  concurrent writes to the same on disk location. That is an error of
>  the layer above us -- it usually indicates a broken lock manager in
>  a cluster file system --, but DRBD has to ensure that both sides
>  agree on which write came last, and therefore overwrites the other
>  write.
>

So this difference to RAID1+NBD is required only if the DLM of the
clustered fs is buggy?


>  More background on this can be found in this paper:
>    http://www.drbd.org/fileadmin/drbd/publications/drbd8.pdf
>
>  Beyond that, DRBD addresses various issues of cluster partitioning,
>  which the MD/NBD stack, to the best of our knowledge, does not
>  solve. The above-mentioned paper goes into some detail about that as
>  well.
>

It would be nice, if you can list those limitations of NBD/RAID here.

Thanks
Nikanth
