Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZGPIEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZGPIEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 04:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbZGPIEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 04:04:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40039 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753175AbZGPIE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 04:04:26 -0400
Date: Thu, 16 Jul 2009 08:59:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: Allow hosts to be flagged as hotpluggable
Message-ID: <20090716085902.782f3fd6@lxorguk.ukuu.org.uk>
In-Reply-To: <1247706748.8632.3.camel@mulgrave.site>
References: <1247701438-18266-1-git-send-email-mjg@redhat.com>
	<1247706748.8632.3.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> However, by definition SATA (like SAS) is a hotplug bus ... why isn't it
> set for some SATA controllers ... is it because the HBA itself does
> something wrong when a hotplug event comes in?

A lot of older controllers emulate various forms of the IDE interfaces.
They don't support detection/reporting of hotplug events to the OS. Some
of them support "warm-plug" - where you tell the controller the device is
going to go away, then remove it, then add a new one, then tell the
controller. Often they need to execute code when told these things (eg to
disable IORDY for PATA devices)

