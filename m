Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbZHNVb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbZHNVb2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:31:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbZHNVb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:31:27 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55545 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755885AbZHNVb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:31:26 -0400
Date: Fri, 14 Aug 2009 22:32:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: How to disable DMA for compact-flash disk?
Message-ID: <20090814223237.1ef61ff1@lxorguk.ukuu.org.uk>
In-Reply-To: <4A85D490.6000701@candelatech.com>
References: <4A81BDA6.4080804@candelatech.com>
	<20090811201206.14556624@lxorguk.ukuu.org.uk>
	<4A85CDCF.3060802@candelatech.com>
	<20090814221038.19e868a0@lxorguk.ukuu.org.uk>
	<4A85D490.6000701@candelatech.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you give me a clue as to what code needs poking?  I'm working
> on the latest 31-rc5 tree, btw.
> 
> 
> PS.  Can't get an ide based 2.6.31-rc5 kernel to boot in F11, though it doesn't seem
> to be related to ide.  I probably have something wrong in my .config.

Tejun made it all very class based so you have inheriting operations
structures thus in pata_via.c find

static struct ata_port_operations via_port_ops = {
        .inherits       = &ata_bmdma_port_ops,

and change it to

static struct ata_port_operations via_port_ops = {
        .inherits       = &ata_bmdma32_port_ops,
