Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbZD2OtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbZD2OtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbZD2Osz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:48:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40921 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757208AbZD2Osy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:48:54 -0400
Date: Wed, 29 Apr 2009 15:48:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
Message-ID: <20090429154831.582e7828@lxorguk.ukuu.org.uk>
In-Reply-To: <20090428223025.GA11997@redhat.com>
References: <20090428223025.GA11997@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But, before fixing, I'd like to understand why we are doing
> 
> 		flush_signal_handlers(current, 1);
> 		sigemptyset(&current->blocked);

Interesting - this appear to be introducing a security hole by clearing
things daemons running setuid apps are entitled to rely upon.

