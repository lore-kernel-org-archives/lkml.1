Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYGSRok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYGSRok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 13:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYGSRoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 13:44:32 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:57103 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbYGSRob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 13:44:31 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, riel@redhat.com
Subject: Re: [PATCH 2/8] slub: Replace ctor field with ops field in /sys/slab/*
References: <Pine.LNX.4.64.0807191530100.13345@sbz-30.cs.Helsinki.FI>
Date: Sun, 20 Jul 2008 02:44:26 +0900
In-Reply-To: <Pine.LNX.4.64.0807191530100.13345@sbz-30.cs.Helsinki.FI> (Pekka
	J. Enberg's message of "Sat, 19 Jul 2008 15:30:25 +0300 (EEST)")
Message-ID: <87tzellqf9.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg <penberg@cs.helsinki.fi> writes:

> +	if (s->ctor) {
> +		x += sprintf(buf + x, "ctor : ");
> +		x += sprint_symbol(buf + x, (unsigned long)s->ctor);
> +		x += sprintf(buf + x, "\n");

How about new "%pS" like following for it? If CONFIG_KALLSYMS=n, it has
difference though...

		x += sprintf(buf + x, "ctor : %pS\n", (unsigned long)s->ctor);
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
