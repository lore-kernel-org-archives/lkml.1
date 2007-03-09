Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbXCIRpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbXCIRpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 12:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbXCIRpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 12:45:45 -0500
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:41164 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752703AbXCIRpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 12:45:44 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=z3GEKwyQcMig0ToRRtYyRvwb2A7hRV/rILcju0uIdXYWFFNWGi+/zGpa/TG+Nu5JN79peBi+D9PgUbyUww37TcdtoHMYbHfPL384dYyptYWM3ZvYG7B0/CmFPmy6KeMN3s0rqxOW6RGmkJIAbwkqDeaUNndyIaKxfK/KKmW9gjM=  ;
X-YMail-OSG: t9._i2QVM1mjwHYcLl6yxKlP3AnIV8yvd8Bw0Z_w7luaLfjUKPEu20aL3erZtDMEzxFk7njLxyi9Y9AFdQGe7iagVwhJEh1Avn6jSz7Wf4slSAn7EBxM9o6YK9VqWENWGnowuqZAr1u0Pfg-
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] i2c-core: i2c bitbang gpio structure
Date: Fri, 9 Mar 2007 09:45:37 -0800
User-Agent: KMail/1.7.1
Cc: Bryan Wu <bryan.wu@analog.com>, Andrew Morton <akpm@linux-foundation.org>,
       Deepak Saxena <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
References: <1173435201.18580.17.camel@roc-desktop> <20070309175540.6bb22798.khali@linux-fr.org>
In-Reply-To: <20070309175540.6bb22798.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703090945.38880.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 8:55 am, Jean Delvare wrote:

> > +struct i2c_bitbang_gpio {
> > +	int sda;
> > +	int scl;
> > +};
> 
> ...
> 
> Also, this structure alone isn't very useful. I'm waiting to see
> drivers actually making use of it before I will consider merging this
> patch at all.

The notion would be that we could have one i2c bitbanger using
the CONFIG_GENERIC_GPIO <asm/gpio.h> interfaces that could work
on most platforms, using that struct for platform_data and the
usual convention for platform device naming.

I'd expect that struct would be merged as part of such a generic
GPIO bitbang driver, and would only be used by that one driver.

SPI could use such a generic bitbanger too.  Until 2.6.21 it's
been missing that last step:  it's needed platform-specific
GPIO calls, so the bitbangers were generic except for those
lowest-level hooks.

- Dave
