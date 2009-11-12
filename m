Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbZKLKWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbZKLKWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 05:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZKLKWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 05:22:30 -0500
Received: from ns.firmix.at ([62.141.48.66]:3096 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbZKLKWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 05:22:30 -0500
Subject: sizeof vs strlen (was Re: [PATCH 4/4] fs/qnx4: decrement sizeof
 size in strncmp)
From: Bernd Petrovitsch <bernd@firmix.at>
To: Julia Lawall <julia@diku.dk>
Cc: al@alarsen.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0911120849260.16627@ask.diku.dk>
References: <Pine.LNX.4.64.0911120849260.16627@ask.diku.dk>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Thu, 12 Nov 2009 11:22:15 +0100
Message-Id: <1258021335.3689.41.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.67 on ns.firmix.at
X-Firmix-Spam-Score: -2.107 () AWL,BAYES_00,FORGED_RCVD_HELO,SARE_SUB_6CONS_WORD,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.107 required=5
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
X-Firmix-Received-Date: Thu, 12 Nov 2009 11:22:35 CET
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-12 at 08:49 +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> As observed by Joe Perches, sizeof of a constant string includes the
> trailing 0.  If what is wanted is to check the initial characters of
> another string, this trailing 0 should not be taken into account.  If an
> exact match is wanted, strcmp should be used instead.
[...]
> strncmp(foo, abc, 
> - sizeof(abc)
> + sizeof(abc)-1
>  )
> // </smpl>
Am I the only one who find "strlen()" instead of "sizeof()-1" here much
more readable (and to the point).

As for run-time, it shouldn't make a difference for static/constant
strings as gcc should be able calculate the length at compile time. And
if the string is not constant, sizeof() is probably wrong anyways.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


