Return-Path: <linux-kernel-owner+w=401wt.eu-S1754268AbXEGJww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbXEGJww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 05:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXEGJww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 05:52:52 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:27833 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbXEGJwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 05:52:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=kIU088z2xTG+dCV6wI49zOsq+eAiDYyytAn6g6VDESWkuccjfL5m/C4D1C06n1Yi+57pzQhN+4xqgLiJd7OZ1ukXf1sGiDaqwi38AGwos/E9IZJ/nVXYYRonWOojI6HcRsQQdEplMX5Y4XDNW/5bKz9T07TQnNyzME0zv9j45AE=
Message-ID: <463EF6ED.7060404@gmail.com>
Date: Mon, 07 May 2007 11:52:45 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: htejun@gmail.com, akpm@osdl.org, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: 2.6.21-mm1: many processes end up in D state
References: <200705052346.l45NksOb022632@harpo.it.uu.se>
In-Reply-To: <200705052346.l45NksOb022632@harpo.it.uu.se>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson napsal(a):
> Jiri: please test the patch below instead. That is, revert to
> the original code _with_ the 'return 1;', and then add this
> patch to it. It should have pretty much the same effect as
> removing the 'return 1;', however calling ata_port_abort()
> is more in line with libata's new-style error handling.
> 
> /Mikael
> 
> --- linux-2.6.21-mm1/drivers/ata/sata_promise.c.~1~	2007-05-05 22:24:41.000000000 +0200
> +++ linux-2.6.21-mm1/drivers/ata/sata_promise.c	2007-05-05 22:25:21.000000000 +0200
> @@ -653,6 +653,8 @@ static void pdc_error_intr(struct ata_po
>  	qc->err_mask |= ac_err_mask;
>  
>  	pdc_reset_port(ap);
> +
> +	ata_port_abort(ap);
>  }
>  
>  static inline unsigned int pdc_host_intr( struct ata_port *ap,
> 

Yes, no freezing anymore.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
