Return-Path: <linux-kernel-owner+w=401wt.eu-S1755376AbYCJV5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376AbYCJV5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbYCJV5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:57:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:52309 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbYCJV5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:57:12 -0400
In-Reply-To: <47D5A585.8050107@tiscali.nl>
References: <47D47B11.1000303@tiscali.nl>	 <20080310084633.5246ecfe@paperstreet.colino.net> <1205136413.8621.3.camel@pasglop> <47D4EFC1.1050403@tiscali.nl> <64d5b5e6dfd0d1820d21db323ef88e25@kernel.crashing.org> <47D5A585.8050107@tiscali.nl>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <1dd996a5ad3a455c91886cacd3243128@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: akpm@linux-foundation.org, "Darrick J. Wong" <djwong@us.ibm.com>,
       benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       lkml <linux-kernel@vger.kernel.org>, Colin Leroy <colin@colino.net>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: ADT746X: logical-bitwise & confusion in set_max_duty_at_crit()
Date: Mon, 10 Mar 2008 22:56:00 +0100
To: Roel Kluin <12o3l@tiscali.nl>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It includes suggested changes by Segher Boessenkool and I think this
> version was tested by Darrick J. Wong

> -	u8 reg;
> +	u8 reg, temp;
>  	struct i2c_client *client = to_i2c_client(dev);
>  	struct adt7473_data *data = i2c_get_clientdata(client);
> -	int temp = simple_strtol(buf, NULL, 10);
> -	temp = temp && 0xFF;
> +
> +	temp = simple_strtol(buf, NULL, 10) & 0xFF;

It still does this superfluous "& 0xff", which hides the lack of
range checking.


Segher

