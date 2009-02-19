Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbZBSMZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbZBSMZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbZBSMZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:25:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:3678 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbZBSMZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:25:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ShsHH3aSH3rNVmNfm3XSezjQCoJYV3SuEO9BHoFiVLZUP2ExL8SwPcfrXyJqr2j87A
         gvTCel30weRdg8ER72f+oIUK/ltiuR4AJg30qw8TOSbTnzAh0FWeJIwIhgU6zVv/i3tN
         S8gR9XlFjMfkTxzCFqJR6AnPAerUsDIvZZbfk=
Date: Thu, 19 Feb 2009 15:24:17 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bikeee
To: =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
cc: Dan Carpenter <error27@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sx.c: fix dbl statement if - add missing braces
In-Reply-To: <Pine.LNX.4.64.0902181547110.31742@wrl-59.cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.0902191518570.3404@bikeee>
References: <Pine.LNX.4.64.0902181547110.31742@wrl-59.cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While we're at it, here is another patch for that file.

The "break" would just result in reusing a free'd pointer.  I don't have 
the cards myself to test it though.  :/

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/char/sx.c	2009-02-19 11:27:51.000000000 +0300
+++ devel/drivers/char/sx.c	2009-02-19 11:29:05.000000000 +0300
@@ -1788,7 +1788,7 @@
  						nbytes - i : SX_CHUNK_SIZE)) {
  					kfree(tmp);
  					rc = -EFAULT;
-					break;
+					goto out;
  				}
  				memcpy_toio(board->base2 + offset + i, tmp,
  						(i + SX_CHUNK_SIZE > nbytes) ?
@@ -1845,6 +1845,7 @@
  		rc = -ENOTTY;
  		break;
  	}
+out:
  	unlock_kernel();
  	func_exit();
  	return rc;
