Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYIYNj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYIYNj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 09:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYIYNjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 09:39:20 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46979 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbYIYNjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 09:39:20 -0400
Date: Thu, 25 Sep 2008 08:39:14 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, serue@linux.vnet.ibm.com,
       zohar@linux.vnet.ibm.com, safford@watson.ibm.com,
       debora@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4][resubmit] TPM: rcu locking
Message-ID: <20080925133914.GC13414@us.ibm.com>
References: <cover.1222136544.git.srajiv@linux.vnet.ibm.com> <1222190371-23814-3-git-send-email-srajiv@linux.vnet.ibm.com> <20080923181922.GE6637@linux.vnet.ibm.com> <1222201173.24276.15.camel@blackbox> <1222261841.24276.28.camel@blackbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222261841.24276.28.camel@blackbox>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rajiv Andrade (srajiv@linux.vnet.ibm.com):
> Reading the code again, we noticed that there's a put_device() missing
> right inside this test:

Oops.  So ignore my other comment  :)

Sorry, I'm behind on some email.

-serge

> >  	if (test_and_set_bit(0, &chip->is_open)) {
> >  		dev_dbg(chip->dev, "Another process owns this TPM\n");
> > -		rc = -EBUSY;
> > -		goto err_out;
> > +		return -EBUSY;
> >  	}
> > 
> Since this was moved to a section before.
> > -	get_device(chip->dev);
> > -
> 
> I'll submit a patch to be applied on top of this one.
> 
> Rajiv Andrade
> IBM Linux Technology Center
> Security Development
> 
