Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbZB0WIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbZB0WIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 17:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760796AbZB0WIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 17:08:35 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:54135 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760704AbZB0WIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 17:08:34 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 27 Feb 2009 14:08:29 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Tony Battersby <tonyb@cybernetics.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6] [-mm] epoll: don't use current in irq context
In-Reply-To: <49A42E33.7020204@cybernetics.com>
Message-ID: <alpine.DEB.1.10.0902271406170.3810@makko.or.mcafeemobile.com>
References: <49A42E33.7020204@cybernetics.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009, Tony Battersby wrote:

> ep_call_nested() (formerly ep_poll_safewake()) uses "current" to detect
> callback recursion, but it may be called from irq context where the
> use of current is generally frowned upon.  It would be better to use
> get_cpu() and put_cpu() to detect the callback recursion.

Oh, I forgot about this one ...
We're not actually dereferencing anything in current, by using it as a 
cookie. But yes, getting the CPU is better, even at preemption expenses.
Thank you for your report Tony.


Acked-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


