Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbYIOSdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbYIOSdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:33:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYIOScS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:32:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:6991 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbYIOScP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=FjZrWLVEiIf87KK3jALA3m+MBvl1J+PPYn6P61YJS4jVADCLPF+z/K0ZLH61TwzbBN
         SRMOBv+3/xoAkHGLRPiD2JvWpZGEWOtm1ISdmT2B27clrfSGI9kLTEafpqe3DuapgEiN
         /DdgSRdFsvPW7lbIbZ1OvpJmryA4EL4e7Gdtc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 07/10] ide-atapi: prepare ide-cd expiry handler
Date: Mon, 15 Sep 2008 20:25:57 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com> <1221392158-3848-8-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1221392158-3848-8-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809152025.57593.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 September 2008 13:35:55 Borislav Petkov wrote:
> Push ide-cd expiry handler into the ide-cd header. Also, pass expiry
> handler to ide_execute_command() in ide_issue_pc() for later.

Uh, no.  Please don't include "ide-cd.h" in ide-atapi.c.  Instead just move
the expiry handler to ide-atapi.c like it was done with ide_scsi_expiry().

It also seems that 'expiry' argument is not needed and expiry handler
to use can be deduced from drive->media and drive->scsi.

patches #8-10 look OK on the quick look but since they depend on
earlier changes they also need to be updated.
