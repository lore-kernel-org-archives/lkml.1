Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbYJHANL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbYJHANL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:13:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYJHAM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:12:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60081 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYJHAMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:12:55 -0400
Message-ID: <48EBFAFC.3020501@zytor.com>
Date: Tue, 07 Oct 2008 17:12:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org,
       "Paoletti, Tomaso" <Tomaso.Paoletti@caviumnetworks.com>
Subject: Re: [PATCH 1/4] serial: 8250 driver replaceable i/o functions.
References: <48EBF426.9080500@caviumnetworks.com> <48EBF56D.3030203@caviumnetworks.com>
In-Reply-To: <48EBF56D.3030203@caviumnetworks.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney wrote:
> /* sane hardware needs no mapping */
> -static inline int map_8250_in_reg(struct uart_8250_port *up, int offset)
> +static inline int map_8250_in_reg(struct uart_port *p, int offset)
> {
> -    if (up->port.iotype != UPIO_AU)
> +    if (p->iotype != UPIO_AU)
>         return offset;
>     return au_io_in_map[offset];
> }

With your changes, these functions cannot be called with p->iotype != 
UPIO_AU anymore, correct?  So there is no need for this test...

	-hpa
