Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbZDMXt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbZDMXt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZDMXts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:49:48 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:56299 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbZDMXts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:49:48 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Scheduling while atomic in tty code with cdc-acm driver, kernel 2.6.29.1
Date: Tue, 14 Apr 2009 01:50:10 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <20090413193633.33ce0710@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <20090413193633.33ce0710@dhcp-100-2-144.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904140150.10790.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 14 April 2009 01:36:33 schrieb Chuck Ebbert:
> BUG: sleeping function called from invalid context at kernel/mutex.c:88
> in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper
> Pid: 0, comm: swapper Not tainted 2.6.29.1-54.fc11.x86_64 #1

Is this specific to 2.6.29.1? It looks like setting low_latency, as cdc-acm,
does for legacy reasons, is harmful now. Please remove these lines:


	/* force low_latency on so that our tty_push actually forces the data 
through,
	   otherwise it is scheduled, and with high data rates data can get lost. */
	tty->low_latency = 1;

	HTH
		Oliver

