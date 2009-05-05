Return-Path: <linux-kernel-owner+w=401wt.eu-S1756342AbZEEXiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342AbZEEXiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 19:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZEEXiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 19:38:14 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49762 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbZEEXiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 19:38:13 -0400
Subject: Re: [PATCH] integrity: lsm audit rule matching fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, david safford <safford@watson.ibm.com>
In-Reply-To: <alpine.LRH.2.00.0905060914300.10864@tundra.namei.org>
References: <1241543568.6101.10.camel@dyn9002018117.watson.ibm.com>
	 <alpine.LRH.2.00.0905060914300.10864@tundra.namei.org>
Content-Type: text/plain
Date: Tue, 05 May 2009 19:38:12 -0400
Message-Id: <1241566692.8625.3.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-06 at 09:14 +1000, James Morris wrote:
> On Tue, 5 May 2009, Mimi Zohar wrote:
> 
> > An audit subsystem change replaced AUDIT_EQUAL with Audit_equal.
> > Update calls to security_filter_rule_init()/match() to reflect
> > the change.
> > 
> > Index: security-testing-2.6/security/integrity/ima/ima_policy.c
> > ===================================================================
> > --- security-testing-2.6.orig/security/integrity/ima/ima_policy.c
> > +++ security-testing-2.6/security/integrity/ima/ima_policy.c
> > @@ -96,7 +96,7 @@ static bool ima_match_rules(struct ima_m
> >  	if ((rule->flags & IMA_UID) && rule->uid != tsk->cred->uid)
> >  		return false;
> >  	for (i = 0; i < MAX_LSM_RULES; i++) {
> > -		int rc;
> > +		int rc = 0;
> 
> Why did you change this?

Based on a reported compiler warning error.

Mimi

