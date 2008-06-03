Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYFCJKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYFCJKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 05:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbYFCJKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 05:10:23 -0400
Received: from aun.it.uu.se ([130.238.12.36]:51256 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbYFCJKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 05:10:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18501.2572.137148.78927@harpo.it.uu.se>
Date: Tue, 3 Jun 2008 11:08:28 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: Re: [RFC PATCH] consolidate within() implementations
In-Reply-To: <48441D35.7010200@de.ibm.com>
References: <48441D35.7010200@de.ibm.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Oberparleiter writes:
 > +static inline int addr_within_len(const void *addr, const void *start,
 > +				  size_t len)
 > +{
 > +	return ((unsigned long) addr >= (unsigned long) start) &&
 > +	       ((unsigned long) addr < ((unsigned long) start + len));
 > +}

On most machines you'd get better code with

	return (unsigned long)((char*)addr - (char*)start) < (unsigned long)len;

Maybe a candidate for a follow-up optimisation patch?
