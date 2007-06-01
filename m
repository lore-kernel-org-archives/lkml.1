Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbXFAWD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbXFAWD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbXFAWDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:03:21 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1855 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbXFAWDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:03:20 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: SELECT() returns 1 But FIONREAD says (Input/output error)
Date: Fri, 1 Jun 2007 15:03:21 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEEAEEAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <46607BC5.4070408@gatworks.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 01 Jun 2007 16:03:44 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 01 Jun 2007 16:03:44 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> David Schwartz wrote:

> >> The misunderstanding is from the docs.
> >> The select() does not report device errors.
> >> Select will just "more precisely, to see if a read will not block".

> > This is a much slighter misunderstanding. The result of the 'select'
> > function tells you nothing about what a particular 'read' will
> > or will not do.

> The docs 'precisely' says that it does. I'm sorry if you cannot trouble
> yourself to read the man pages to address your issues with the correct
> functionality of the select call.

No, that's not what the docs say. That's what the docs are frequently
misunderstood to say, but that is not what they actually say. When they say,
for example, "see if a read will not block", they mean a hypothetical
concurrent read that does not take place, not a future actual read.

It's bad wording, but it is not incorrect unless you choose to misunderstand
it. For example, one could write that the 'access' function tells you if an
"'open' will succeed", but that doesn't mean an 'open' after an 'access'
*must* succeed.

Like all status-reporting functions, 'select' tells you information that is
accurate at some point in-between when you called it and when it returned
that value to you. But it makes no predictions about the future, and the
documentation does not say that it does. It does imply that it does, and
that's why it's important to correct this misconception whenever it comes
up.

POSIX's documentation is a bit clearer, saying "would block" rather than
"will block". This helps to make it clear that we're talking about a
hypothetical concurrent operation, not an actual future one.

DS


