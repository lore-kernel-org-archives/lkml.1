Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbYIELVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbYIELVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 07:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYIELVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 07:21:06 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:37169 "EHLO
	cs181073102.pp.htv.fi" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751858AbYIELVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 07:21:05 -0400
To: linux-kernel@vger.kernel.org
Subject: Re: How to find origin PID of a sk_buff in iptables match?
References: <b8ixO-2NS-5@gated-at.bofh.it>
From: Markku Savela <msa@moth.iki.fi>
In-Reply-To: <b8ixO-2NS-5@gated-at.bofh.it> (Markku Savela's message of "Thu\, 04 Sep 2008 10\:40\:08 +0200")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
Date: Fri, 05 Sep 2008 14:21:03 +0300
Message-ID: <877i9qu9cw.fsf@burp.tkv.asdf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Also, I noticed that in my match code in OUTPUT chain, the current
> task seemed to the originator I want (ping test). However, I'm not
> quite sure whether this is always true?

Well, nobody answered.

Anyway, as suspected with TCP connections it seems that current->pid
produces 0 very often after the first initial packet (SYN). I take
this to mean, that the TCP engine is being executed on some interrupt
context?

Now I'm wondering how SELINUX manages to get the secmark right, as the
code in iptables seems to eventually need the current task context?
Something tricky being made using the SECMARK and CONNSECMARK? It
seems to trust, that at least the first packet has the current task
context properly set and the remaining packets of the connection don't
need current task?

I guess I have to dug deeper in this (emulate what SELINUX does). Or
can someone point to a tutorial description on how to reliably
associate each outgoing packet with some originating task context?
