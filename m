Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbZFTOU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbZFTOU4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 10:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbZFTOUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 10:20:44 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56075 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521AbZFTOUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 10:20:43 -0400
Subject: Re: generic_make_request fucntion for scsi_disk
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ravish Tayal <ravish.tayal@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <e42309110906200705j6a731ecay204969f639af5330@mail.gmail.com>
References: <e42309110906200705j6a731ecay204969f639af5330@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 09:20:40 -0500
Message-Id: <1245507640.4255.6.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-20 at 19:35 +0530, Ravish Tayal wrote:
> I am debugging Filesystem code for USB mass storage devices.  I need
> help to figure out after generic_make_request how the request is
> placed to scsi disk (sd) requeset queue and than how sd qeueuecommand
> to usb_storeage thread.  (in which context, is it system call context)

requests out of the lower end of block come from the elevators.  The
elevators can operate in a variety of contexts: user, kernel thread or
softirq depending on state.

The mechanism for queueing to the USB thread is in
scsiglue.c:queuecommand() it's basically a simple single command
consumer model: fill in slot and wake thread.

James


