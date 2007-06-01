Return-Path: <linux-kernel-owner+w=401wt.eu-S1762433AbXFAQnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762433AbXFAQnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 12:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761119AbXFAQn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 12:43:29 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2106 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761066AbXFAQn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 12:43:28 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <netbeans@gatworks.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: SELECT() returns 1 But FIONREAD says (Input/output error)
Date: Fri, 1 Jun 2007 09:43:04 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEBGEEAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <465F7C2A.5020702@gatworks.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 01 Jun 2007 10:43:31 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 01 Jun 2007 10:43:31 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> David Schwartz wrote:

> > Nope. An errored connection is always ready for read/write -- there is
> > nothing to wait for as far as the kernel is concerned. Your code keeps
> > asking the kernel if something interesting has happened, the
> > kernel keeps
> > telling it yes, and it refuses to do anything about it.

> The select() returns because i pulled the USB cable from hub. Seems
> reasonable.

Good. Then there is nothing further to discuss.

> The next select() found what? to be interesting in order to prematurely
> terminate the select-wait? As far as I can tell, nothing interesting has
> happened since the previous select(). In this case the select() is only
> looking at read()'s.

You have a very serious misunderstanding of what 'select' does. The 'select'
function is level triggered and state based, not edge triggered or event
based. The situation was the same as before, and so the same result is
required.

The kernel assumes that either you handled the error condition or you aren't
going to handle the error condition. In either case, the correct thing to do
is to again inform you of the error.

Suppose the first 'select' comes from code that is just curious how many
sockets are ready but has no intention of handling the events. Not reporting
the error on the next call to 'select' would be disastrous.

DS



