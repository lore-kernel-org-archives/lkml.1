Return-Path: <linux-kernel-owner+w=401wt.eu-S1759762AbZDLKU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762AbZDLKU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 06:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756957AbZDLKUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 06:20:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55551 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756462AbZDLKUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 06:20:16 -0400
Date: Sun, 12 Apr 2009 11:21:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ben Castricum" <lk0904@bencastricum.nl>
Cc: <linux-kernel@vger.kernel.org>, dwmw2@infradead.org
Subject: Re: 2.6.30-rc1 problems with firmware loading
Message-ID: <20090412112115.37fe1141@lxorguk.ukuu.org.uk>
In-Reply-To: <8D207FA0B5B5443FAA8178A23C6CA5B9@Seven>
References: <8D207FA0B5B5443FAA8178A23C6CA5B9@Seven>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Apr 2009 08:20:21 +0200
"Ben Castricum" <lk0904@bencastricum.nl> wrote:

> 
> I seem to have some problems with firmware loading since 2.6.30-rc1. Each 
> request seems to time out and reports like these are appearing:

At first glance it looks like the module loading changes are expanding
vmas that don't have an owner (->mm) and are not set no account. So the
VM accounting code in strict overcommit modes doesn't know who to bill
for the pages.

