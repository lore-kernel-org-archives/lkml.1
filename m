Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZFFFlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZFFFlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 01:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750721AbZFFFlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 01:41:13 -0400
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:31343 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750720AbZFFFlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 01:41:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=khc6ZelcXxXi3mqwjdZMwCf45TCDu97gj+EEVXBRsPGCz5UnGtf7h5KeMdvNvlfAKyvjZgzkatbRcjrJnRXKZCPVoq+O7PQwitkN6B14qHUpaRMS2NwscXnmbdy7JyC4HusUKd7N+B19sZvdqQTRvtyVQ4NkWJGyrTCdgn9P3GQ=  ;
X-YMail-OSG: 4IvyH9gVM1nWPdfZR1RjrsccjfZsSwbSeT0NkItkWDMq6bF7wtbIEZtNjgfIDRJxdk3wrNR0mDE9WhKcar2ijFWWrKj8bNypeDffBsSpOfHERmyN4IbS6PBdiuVhsZMarKpTo1CmdYJjYkyxO8dCrq2tqGzWtOEIc.J_EQhfGRqqIvWGMfzM30Nfj7zd64susQreCuv4qLPl1zIMHGUT437w5uKw6qeI63WRd1RSBIN9fvKdbAvrJ0_XXK_oYe9PGTHKwYygeHM12ZCg_aAtyfPzfHrbA.ffu_OqGUqfVeQBTqoWbbg-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Daniel =?iso-8859-1?q?Gl=F6ckner?= <dg@emlix.com>
Subject: Re: [PATCH] gpiolib: allow poll on gpio value
Date: Fri, 5 Jun 2009 22:41:13 -0700
User-Agent: KMail/1.9.10
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
References: <1244212590-15620-1-git-send-email-dg@emlix.com>
In-Reply-To: <1244212590-15620-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906052241.13638.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009, Daniel Glöckner wrote:
> +       else {
> +               int i;
> +               status = 0;
> +               for (i = 0; i < ARRAY_SIZE(trigger_types); i++)
> +                       if ((desc->flags & ((1 << FLAG_TRIG_FALL)
> +                                        | (1 << FLAG_TRIG_RISE)))
> +                            == trigger_types[i].flags) {
> +                               status = sprintf(buf, "%s\n",
> +                                                trigger_types[i].name);
> +                               break;
> +               }
> +       }

Looks pretty clean overall, but that snippet highlights some cosmetic
issues I'd like to see cleaned up:

	- Blank line after each declaration block -- "int i" above.

	- Prefer BIT(n) to (1 << n)

	- And here, the ((1 << FLAG_TRIG_FALL) | (1 << FLAG_TRIG_RISE))
	  thing shows up all over, maybe #define as GPIO_TRIGGER_MASK

	- That "== triger_types[..]" should use only tabs for indent.

And yes, like Ben I think this functionality is probably worth having,
since it's not something that *can* really be done from userspace with
the current calls.

- Dave
