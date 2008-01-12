Return-Path: <linux-kernel-owner+w=401wt.eu-S1763340AbYALUUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763340AbYALUUx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759053AbYALUUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:20:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:21337 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082AbYALUUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:20:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=HgRSt6DhFwT5vCVrJu+sy2rYR9prro8s7wye26hCmn3ndPBrv9T9gvDPwn92d5z07xdUTTJdI1QvhzDj5foYCsnBN+vAfnW1fbAeOLuQtHs88Oik+PWY0mP/I0vxzjONRSmoKNh4k7ki8JgL7XSYhL07zCfFw6ruMWiqZOpBC8I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 06/21] ide-floppy: remove struct idefloppy_flexible_disk_page
Date: Sat, 12 Jan 2008 21:15:29 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-7-git-send-email-bbpetkov@yahoo.de> <200801120158.57895.bzolnier@gmail.com>
In-Reply-To: <200801120158.57895.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801122115.29227.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 12 January 2008, Bartlomiej Zolnierkiewicz wrote:

[...]

> > -	header = (idefloppy_mode_parameter_header_t *) pc.buffer;
> > -	floppy->wp = header->wp;
> > +	floppy->wp = pc.buffer[3] & 0x80;
> 
> This is not an equivalent transformation:
> 
> header->wp is 0 or 1
> pc.buffer[3] & 0x80 is 0 or 0x80
> 
> It seems to work fine for ->wp (because it is needlessly defined as 'int')
> but may seriously confuse set_disk_ro() and thus bdev_read_only() users.
> 
> Should be fixed to '(pc.buffer[3] & 0x80) ? 1 : 0' (or something similar).

Update: this change belongs to patch #10 (+ the need for such change in
patch #6 is a hint that #10 should be before #6)
