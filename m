Return-Path: <linux-kernel-owner+w=401wt.eu-S1760149AbXLUHlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760149AbXLUHlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 02:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbXLUHlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 02:41:08 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31765
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882AbXLUHlH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 02:41:07 -0500
Message-Id: <476B7C33.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 21 Dec 2007 07:41:23 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Dave Jones" <davej@redhat.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Jan Beulich] [PATCH] constify tables in
	kernel/sysctl_check.c
References: <m1r6hh6jsy.fsf@ebiederm.dsl.xmission.com>
 <20071221023031.GA23320@redhat.com>
In-Reply-To: <20071221023031.GA23320@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for catching this!

>>> Dave Jones <davej@redhat.com> 21.12.07 03:30 >>>
On Thu, Dec 20, 2007 at 04:14:05PM -0700, Eric W. Biederman wrote:

 > Remains the question whether it is intended that many, perhaps even
 > large, tables are compiled in without ever having a chance to get used,
 > i.e. whether there shouldn't #ifdef CONFIG_xxx get added.

 > -static struct trans_ctl_table trans_net_ax25_param_table[] = {
 > +static const struct trans_ctl_table trans_net_ax25_table[] = {

we lost the _param, which will cause a duplicate definition with ..
 
 > -static struct trans_ctl_table trans_net_ax25_table[] = {
 > +static const struct trans_ctl_table trans_net_ax25_table[] = {

cut-n-paste thinko ?

	Dave

-- 
http://www.codemonkey.org.uk

