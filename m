Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbZCKUR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbZCKUR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 16:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZCKURs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 16:17:48 -0400
Received: from n13.bullet.mail.mud.yahoo.com ([68.142.206.40]:35051 "HELO
	n13.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750854AbZCKURs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 16:17:48 -0400
X-Yahoo-Newman-Id: 703341.84077.bm@omp405.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WWIN3gGk50clR3oDTIGrBvxZvXOkowpjrKB8C7IQ3WnfOwAf0Y7RE2gilkDJHD9IGUatpAwdcKdCjft7HlG4RVMk4TxTram60oBRlyYKKO8CwoB4ERPJTwQveAu72cim7nuJJo+7+M9FulKMmytE+FL+E9ZAkFx8LqGIQOFUZjw=  ;
X-YMail-OSG: 8uDqbM8VM1kLz5HtfMkJC4NNpfJfapyX7y8wt5j6.zY9YS91CLhwSq03FW2ygn_u6ibuTIyxEjrGzfGf85eQylUYSPKjks_Yl4LxYfI5C9KiCTNHT424UQdQYIFKyo7.js8yhWJU27Nv_XCcFleH4HSj
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Wolfgang =?iso-8859-1?q?M=FCes?= <wolfgang.mues@auerswald.de>
Subject: Re: [PATCH 5/7] mmc_spi: allow higher timeouts for SPI mode
Date: Wed, 11 Mar 2009 12:17:42 -0800
User-Agent: KMail/1.9.10
Cc: "Matt Fleming" <matt@console-pimps.org>,
       "Pierre Ossman" <drzeus@drzeus.cx>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <20090311154605.GD1475@console-pimps.org> <200903111714.15911.wolfgang.mues@auerswald.de>
In-Reply-To: <200903111714.15911.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903111317.42696.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 March 2009, Wolfgang Mües wrote:
> > Is there a reason that you didn't implement this with msleep()
> > as was noted in the comment above the timeout?
> 
> Yes. msleep() is a busy waiting. It is implemented in terms of usleep(),
> which is also busy waiting. The old comment is wrong.

I think you're confused.  A *delay() call will busy-wait.
But a *sleep() call like msleep() will schedule.

(These speed concerns apply primarily to patch #6, not
this one ...)

