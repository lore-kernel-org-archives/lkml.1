Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbYITAl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbYITAl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 20:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYITAls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 20:41:48 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:41554 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752719AbYITAlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 20:41:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zpASpmDQtDq6XbutQVIk6cEu2Q+EChNV7+yJofTGbjzesfIruVCV8KX9gKUE27Mt17AH21RIL0IKnCf7hf2kzWTgYdGTBOa3PyvMNjUTERW7Bi/06v1J9BpIqfGY/LXB5lP9MyJxuqRdefkjPlocloGkikNb7jyseOZMjFxOudE=  ;
X-YMail-OSG: 1ClvzmsVM1lan90cIsXRZmuVwihHS6Kt3uO7vhmBO4ESmJJx0xzgDwH3lR6hB2PaiAGlTQvWNyUGPCAG7yUxWsPLKpQMky3Uw7vcO3pcutavYDyXmAfqOsyB1rw6REdUFsQD5dr0
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH 3/5] watchdog: cleanup a bit omap_wdt.c
Date: Fri, 19 Sep 2008 17:41:44 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-3-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-4-git-send-email-felipe.balbi@nokia.com>
In-Reply-To: <1221820359-8943-4-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809191741.44986.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 September 2008, Felipe Balbi wrote:
>  static int omap_wdt_open(struct inode *inode, struct file *file)
>  {
> -       struct omap_wdt_dev *wdev;
> -       void __iomem *base;
> -       wdev = platform_get_drvdata(omap_wdt_dev);
> -       base = wdev->base;
> +       struct omap_wdt_dev *wdev = platform_get_drvdata(omap_wdt_dev);
> +       void __iomem *base = wdev->base;
> +

Oh, I see where "omap_wdt_dev" (global) gets used.  The normal
way to do stuff like that is using void* pointers placed in the
inode and file structures for exactly that purpose.


