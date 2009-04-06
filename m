Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbZDFIbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbZDFIbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 04:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZDFIbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 04:31:12 -0400
Received: from smtp115.mail.mud.yahoo.com ([209.191.84.164]:23430 "HELO
	smtp115.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753264AbZDFIbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 04:31:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zeI80hJrzU0ezPqGVAiLWs88EYY8bIKolv+83hwFXz2aovD/EmRSXhhDmU6E7nZZUxPNsdBOWvaA5m4w0lXQM4mYQAgB+Wul4aV3vMl6zQTWJ1YNbQuxFLFdCT+txwhvdog2xab0Bs+Wo4bzvIUVDNF6MOe6zss4nsbCLFQvlzs=  ;
X-YMail-OSG: .N1zHigVM1nJ2Nj_9q1KHYRYMYhx494ogHE7koTsE6J7L5JDOhjv2qnBU9cP6nThPAq5gWNi4lw8aBSli1dRy9KkGlwLT_W2sfAv_OjCwgaQwIl8G_M8gD73kYs53R0Jnb91pMLVKBOMAJGn_37NaZpwX7RRUw.OGhmV7e.M5ITJJ1fEP0bAld.dyMArnTSZ70reCuplx6iJucQVB0FHSnSIB52Eac1Yx2NeBL_fO8W5WHnmmetJQ2H77L0djSTeNsYZHvHfl1OLj71Eneqo71ySdlREGDGvPqLwTiK9X0vs33A2TPrWMp983fifpHpG.tv8qy8c7Uzs4c529YbGKV1cJg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 21/41] CacheFiles: Permit the page lock state to be monitored [ver #48]
Date: Mon, 6 Apr 2009 18:31:03 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org
References: <200904050122.42081.nickpiggin@yahoo.com.au> <200904041709.31651.nickpiggin@yahoo.com.au> <951.1238883213@redhat.com>
In-Reply-To: <951.1238883213@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904061831.03753.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 April 2009 08:13:33 David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> > On Saturday 04 April 2009 17:09:31 Nick Piggin wrote:
> > > On Saturday 04 April 2009 02:56:24 David Howells wrote:
> > > > Add a function to install a monitor on the page lock waitqueue for a
> > > > particular page, thus allowing the page being unlocked to be detected.
> > > > 
> > > > This is used by CacheFiles to detect read completion on a page in the
> > > > backing filesystem so that it can then copy the data to the waiting
> > > > netfs page.
> > > 
> > > This is the only thing I'm still worried about in core code. The extra
> > > page flag (which is probably unusable for any other fs, due to its
> > > semantics) is an issue, but Andrew seemed like he was willing to spend
> > > *2* page flags on this, so I'm sure he's happy with 1.
> > 
> > Well that is to say it is not a such a bad concept to have...
> 
> What is not such a bad concept to have?  Having an extra page flag?

Notification call when a page read is completed.


> > actually we already have exactly this concept which is what should be used.
> > Ie. the filesystem's io completion handler.
> 
> Which filesystem's I/O completion handler?

Whichever one that you require such information from.
