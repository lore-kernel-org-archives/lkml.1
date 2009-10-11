Return-Path: <linux-kernel-owner+w=401wt.eu-S1751161AbZJKF0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbZJKF0p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 01:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbZJKF0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 01:26:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:49338 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbZJKF0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 01:26:44 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ben Efros <ben@pc-doctor.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, fangxiaozhi <huananhu@huawei.com>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>,
       Josua Dietze <digidietze@draisberghof.de>
In-Reply-To: <32355889.563271255220486481.JavaMail.root@mail.pc-doctor.com>
References: <32355889.563271255220486481.JavaMail.root@mail.pc-doctor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Oct 2009 16:24:41 +1100
Message-Id: <1255238681.2192.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-10 at 17:21 -0700, Ben Efros wrote:
> 
> Ben Herrenschmidt's patch[1] to retry without SANE_SENSE might be
> combined be able to be used to detect this 'INSANE_SENSE' scenario,
> but not in its current form.
> 
> Devices lying about the "additional sense length" doesn't seem all
> that common, so it might be better to just flag the device as insane
> and not worry about reworking Ben Herrenschmidt's patch.

I don't like flagging devices ... though we already somewhat do it for
the mode switch so it would be possible to stick the flag there.

Another option is to set the insane flag from a retry path similar
to what I posted so that it doesn't ping pong.

In any case, a decision should be made soon as current -stable is broken
and these devices are very common.

Cheers,
Ben. 

