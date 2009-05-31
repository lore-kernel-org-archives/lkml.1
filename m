Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbZEaQRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbZEaQRw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 12:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbZEaQRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 12:17:44 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:59163 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698AbZEaQRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 12:17:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=Rds8DTkn8ZMurg2szV6y7KaYTtZTetZE7ettVywvffmHlQ8LQ6DnZyqcCdkA2yzo/T
         FuG8BQlDin/lfEaox0CYsLGGNe1ZWudxH0JwLkBkBIv5LdudWkofNPvfET49f+IQL5ET
         LkZYom/3YO9kMLGViVfyZhB9uZbOgjqA92XwE=
Date: Sun, 31 May 2009 18:17:41 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: broken ide-tape
Message-ID: <20090531161740.GA7975@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <4A229998.6070808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A229998.6070808@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 31, 2009 at 04:52:08PM +0200, Jiri Slaby wrote:
> Hi,
> 
> ide-tape is broken since commit 346331f82823682fb5c2df6e827db25d95cc2e92
> (ide-tape: remove atomic test/set macros for packet commands)
> from Apr 18 2008.
> 
> The commit introduced flags which are defined as (1 << nr) and uses them
> in {clear,set,test}_bit. And hence it must oops on each do_request.

/me ducks behind the couch.

Ouch, that _is_ dumb, sorry. This is because we wanted to keep the
atomic ops for the pipeline handling (which got removed) and use
simple flags for the rest. And so the flags got mixed up and the mess
unleashed...

> Is it worth fixing (something like ilog2 added to each bit operation) or
> is a complete removal of the driver better "fix"?

Actually, the driver needs to be reaudited and fixed properly - we still
have some users left. I'm looking into it.

Thanks for catching that.

-- 
Regards/Gruss,
    Boris.
