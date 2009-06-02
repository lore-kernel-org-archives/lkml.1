Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbZFBNbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbZFBNbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZFBNbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:31:07 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:64362 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbZFBNbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:31:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Ud4B07OSoRa3l3aFAbB5dF4NUCvpk51UjnMZM9CyIFL3m2ynIYD0rhlVJDlvno5TxT
         cIyZ0B3yitcd4BjV54NezVX+AfxfvHyIG3Zhufcip/4KMa/PF0y8+tS3ZQrCrzQtCV5j
         EHMYoZedpJKVPCj9cGopvM/vX41sLE69ON5IA=
MIME-Version: 1.0
In-Reply-To: <1243817268.4375.28.camel@concordia>
References: <d970ff420905291307p62e9c6eck772e7ee3757ee44a@mail.gmail.com>
	 <1243817268.4375.28.camel@concordia>
Date: Tue, 2 Jun 2009 10:24:15 -0300
Message-ID: <d970ff420906020624r6988e99aq2d3ddae26e0d6585@mail.gmail.com>
Subject: Re: MPC8343 - serial8250: too much work
From: Alemao <xcarandiru@gmail.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In a normal situation, I have something like this:

serial8250_interrupt()
serial8250_handle_port()
transmit_chars()
pass_counter: 0
serial8250_handle_port()
pass_counter: 1
serial8250_handle_port()
pass_counter: 2
pass_counter: 3


But when the problem happends:

serial8250_interrupt(16)
serial8250_handle_port()
transmit_chars()
uart_circ_empty()
pass_counter: 0
.
.
.
serial8250_handle_port()
transmit_chars()
uart_circ_empty()
pass_counter: 257
serial8250: too much work for irq16

If the circ buffer is empty, why iterate 256 times?

How can I trace the application that is calling serial routines?

Its difficult to debug cause I use serial console to communicate with the board.

Thanks in advance,

--
Alemao
