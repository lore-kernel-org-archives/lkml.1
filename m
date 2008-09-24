Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbYIXNMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbYIXNMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 09:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYIXNMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 09:12:13 -0400
Received: from igw1.br.ibm.com ([32.104.18.24]:47210 "EHLO igw1.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYIXNMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 09:12:12 -0400
Subject: Re: [PATCH 3/4][resubmit] TPM: rcu locking
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       serue@linux.vnet.ibm.com, zohar@linux.vnet.ibm.com,
       safford@watson.ibm.com, debora@linux.vnet.ibm.com
In-Reply-To: <1222201173.24276.15.camel@blackbox>
References: <cover.1222136544.git.srajiv@linux.vnet.ibm.com>
	 <1222190371-23814-3-git-send-email-srajiv@linux.vnet.ibm.com>
	 <20080923181922.GE6637@linux.vnet.ibm.com>
	 <1222201173.24276.15.camel@blackbox>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 10:10:41 -0300
Message-Id: <1222261841.24276.28.camel@blackbox>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reading the code again, we noticed that there's a put_device() missing
right inside this test:

>  	if (test_and_set_bit(0, &chip->is_open)) {
>  		dev_dbg(chip->dev, "Another process owns this TPM\n");
> -		rc = -EBUSY;
> -		goto err_out;
> +		return -EBUSY;
>  	}
> 
Since this was moved to a section before.
> -	get_device(chip->dev);
> -

I'll submit a patch to be applied on top of this one.

Rajiv Andrade
IBM Linux Technology Center
Security Development


