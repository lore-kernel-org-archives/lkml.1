Return-Path: <linux-kernel-owner+w=401wt.eu-S1751531Ab0ARNVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab0ARNVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 08:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340Ab0ARNVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 08:21:17 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:47435 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab0ARNVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 08:21:15 -0500
From: "Chaithrika U S" <chaithrika@ti.com>
To: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>
Cc: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <davinci-linux-open-source@linux.davincidsp.com>,
       <khilman@deeprootsystems.com>, <akpm@linux-foundation.org>
References: <1263386121-6644-1-git-send-email-chaithrika@ti.com> <20100113134445.010d4f1c@lxorguk.ukuu.org.uk>
In-Reply-To: <20100113134445.010d4f1c@lxorguk.ukuu.org.uk>
Subject: RE: [PATCH] serial: 8250: Add cpufreq support
Date: Mon, 18 Jan 2010 18:47:49 +0530
Message-ID: <000c01ca9840$a1fb99b0$e5f2cd10$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcqUU+px6G99AweuTPe3dzZQV7F/wAD7IT2w
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 19:14:45, Alan Cox wrote:
> > +static int serial8250_cpufreq_transition(struct notifier_block *nb,
> > +					     unsigned long val, void *data)
> > +{
> > +	struct uart_8250_port *p;
> > +	struct uart_port *uport;
> > +
> > +	p = container_of(nb, struct uart_8250_port, freq_transition);
> > +	uport = &p->port;
> > +
> > +	if (IS_ERR(p->clk))
> > +		goto cpu_freq_exit;
> > +
> > +	if (p->port.uartclk == clk_get_rate(p->clk))
> > +		goto cpu_freq_exit;
> > +
> > +	p->port.uartclk = clk_get_rate(p->clk);
> > +	if (val == CPUFREQ_POSTCHANGE) {
> > +		struct ktermios *termios;
> > +		struct tty_struct *tty;
> > +		if (uport->state == NULL)
> > +			goto cpu_freq_exit;
> > +
> > +		tty = uport->state->port.tty;
> 
> Need locking on port->tty.
> 
> > +		if (tty == NULL)
> > +			goto cpu_freq_exit;
> > +
> 
> Need locking on tty->termios
> 
> I'd say this is also probably at the wrong level - why not do it at the
> uart_port level instead (ie move the code you have into serial_core using
> uart_port) - you've made it all nicely generic already.
> 
> Alan
> 	
	
Thank you for the review comments.
I will submit an updated version of patch soon.

Regards, 
Chaithrika


