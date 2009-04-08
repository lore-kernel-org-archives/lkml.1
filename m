Return-Path: <linux-kernel-owner+w=401wt.eu-S1762350AbZDHP5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762350AbZDHP5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760855AbZDHP4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:56:54 -0400
Received: from mail.pikewerks.com ([24.96.136.236]:52405 "EHLO
	mail.pikewerks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777AbZDHP4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:56:53 -0400
Message-ID: <49DCC936.70509@pikewerks.com>
Date: Wed, 08 Apr 2009 08:56:38 -0700
From: Matt Klein <matt.klein@pikewerks.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Cached IO Synchronization Question
References: <49DA7498.3050000@pikewerks.com> <1239204217.4557.2590.camel@laptop>
In-Reply-To: <1239204217.4557.2590.camel@laptop>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Note how do_generic_file_read() checks PageUptodate() and does a
> lock_page_killable() in case its not.
> 
> 
> 

As far as I can tell there is nothing to prevent the page from becoming
out of date (or someone doing a full page cached write) after the
PageUptodate() check returns up to date.

So I have concluded that cached read/write interleaving is not
synchronized. This is the behavior found on Windows.
