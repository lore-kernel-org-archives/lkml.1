Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbZD2Fzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbZD2Fzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZD2Fzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:55:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858AbZD2Fzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:55:39 -0400
Date: Tue, 28 Apr 2009 22:53:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 20/30] microblaze_mmu_v1: uaccess MMU update
Message-Id: <20090428225352.4a54f277.akpm@linux-foundation.org>
In-Reply-To: <1240821139-7247-21-git-send-email-monstr@monstr.eu>
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>
	<1240821139-7247-5-git-send-email-monstr@monstr.eu>
	<1240821139-7247-6-git-send-email-monstr@monstr.eu>
	<1240821139-7247-7-git-send-email-monstr@monstr.eu>
	<1240821139-7247-8-git-send-email-monstr@monstr.eu>
	<1240821139-7247-9-git-send-email-monstr@monstr.eu>
	<1240821139-7247-10-git-send-email-monstr@monstr.eu>
	<1240821139-7247-11-git-send-email-monstr@monstr.eu>
	<1240821139-7247-12-git-send-email-monstr@monstr.eu>
	<1240821139-7247-13-git-send-email-monstr@monstr.eu>
	<1240821139-7247-14-git-send-email-monstr@monstr.eu>
	<1240821139-7247-15-git-send-email-monstr@monstr.eu>
	<1240821139-7247-16-git-send-email-monstr@monstr.eu>
	<1240821139-7247-17-git-send-email-monstr@monstr.eu>
	<1240821139-7247-18-git-send-email-monstr@monstr.eu>
	<1240821139-7247-19-git-send-email-monstr@monstr.eu>
	<1240821139-7247-20-git-send-email-monstr@monstr.eu>
	<1240821139-7247-21-git-send-email-monstr@monstr.eu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 10:32:09 +0200 monstr@monstr.eu wrote:

> +#define __clear_user(addr, n)	(memset((void *)(addr), 0, (n)), 0)

__clear_user() already takes a void* argument, so the cast is hopefully
unneeded and undesirable.  The same applies to many other
architectures.  If someone is passing a non-pointer type to
__clear_user() then that's potentially a bad thing which we want to
know about.

IOW, someone screwed up and everyone copied it :(

