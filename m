Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbZCCVIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbZCCVIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 16:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbZCCVIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:08:35 -0500
Received: from n17.bullet.mail.mud.yahoo.com ([68.142.206.144]:30609 "HELO
	n17.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753612AbZCCVIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:08:34 -0500
X-Yahoo-Newman-Id: 169175.40441.bm@omp410.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dNWG+Unn2Qq5cH/KjF5xlxi+xKyU0OWp9HT2f64h343Z7etO2vtzQ1JQ3kbMbpz49tyf1EaQytwtpgeoxseOzu//ka67YalGqbxr+qCuzcUG+PWVP6R6+kYEbG8+0aYrG8q/ZiU28aMabo8htzodx30wU0i7Iv1/pqkQnRUM5AU=  ;
X-YMail-OSG: c7nl6DoVM1nL0RheEG95pJ.qdQ.q6f9_hbay80vM7RnDOLKY2GTaPfZJSujebH7kVYb.jQj8uRIWxso9cAuzQulEklh4MeCJjeU6sebTn0qWehidJ2rGezYUIW7lYPmIyhlYiUZWnSpHu1XPyicwZSrt
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH] rtc-v3020: add ability to access v3020 chip with GPIOs
Date: Tue, 3 Mar 2009 13:08:29 -0800
User-Agent: KMail/1.9.10
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org, raph@8d.com
References: <cover.1235400430.git.mike@compulab.co.il> <20090302124737.03075958@i1501.lan.towertech.it> <49ABCEB3.6090100@compulab.co.il>
In-Reply-To: <49ABCEB3.6090100@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903031308.29933.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Mike Rapoport wrote:
> +
> +#define V3020_CS       0
> +#define V3020_WR       1
> +#define V3020_RD       2
> +#define V3020_IO       3
> +
> +struct v3020_gpio {
> +       const char *name;
> +       unsigned int gpio;
> +};
> +

> +static struct v3020_gpio v3020_gpio[] = {
> +       { "RTC CS", 0 },
> +       { "RTC WR", 0 },
> +       { "RTC RD", 0 },
> +       { "RTC IO", 0 },
> +};

After Andrew's fault path cleanup it looks OK, but I see
no point to that GPIO struct with the name.  You know the
name based on the position, if you ever need one.  Take
that away, and you can add my ack.


Also, best not to have a single static struct; there's
no need to add a driver restriction that there be only
one of these chips in a system.

- Dave



