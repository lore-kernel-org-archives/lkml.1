Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbYEGGPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbYEGGPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbYEGGP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:15:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:59457 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbYEGGP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:15:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=x4d27KQMdG3cs43v4fAgB71ii9Q80fMAa4Tnsx6WR0nGZ+T3lE03Fq9QoEYqy/l++GrTccGwH69ocTMIrS30erq/FOWSEy1V4hnYRhVHYMpm/G1d8WNs4jEDOS/IbcDMpkIxU+mQuruyK+yZKZ6t+9Zp5SRqTIXzCoQP4drvO/U=
Message-ID: <e2e108260805062315n15e84abck5f4207a6a7a11805@mail.gmail.com>
Date: Wed, 7 May 2008 08:15:23 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Yigal Sadgat" <YSadgat1@gcte.com>
Subject: Re: Compact Flash Question
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jwboyer@linux.vnet.ibm.com, joern@logfs.org
In-Reply-To: <005b01c8afc4$77f4ec90$6401a8c0@techwriter>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <005b01c8afc4$77f4ec90$6401a8c0@techwriter>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 11:59 PM, Yigal Sadgat <YSadgat1@gcte.com> wrote:
> (2) An engineer at SanDisk Engineering told me NOT to do wear leveling.
> The file allocation table is written very frequently back into the flash. So
> is it really safe to assume that I don't need wear leveling???

For most Linux filesystems you really need wear leveling. E.g. ext3's
superblock is at a fixed location and gets overwritten frequently.
Without wear leveling you risk that the flash sector where the
superblock resides wears out early.

When using ext3 on a CompactFlash, you can limit the number of writes
to the CompactFlash significantly by mounting the medium with
parameters like noatime,nodiratime,commit=300.

Bart.
