Return-Path: <linux-kernel-owner+w=401wt.eu-S1030800AbXAZGgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030800AbXAZGgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030803AbXAZGgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:36:39 -0500
Received: from smtp.osdl.org ([65.172.181.24]:48264 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030800AbXAZGgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:36:37 -0500
Date: Thu, 25 Jan 2007 22:36:09 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Cedric Le Goater <clg@fr.ibm.com>,
       Daniel Hokka Zakrisson <daniel@hozac.com>, herbert@13thfloor.at,
       trond.myklebust@fys.uio.no,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH] namespaces: fix exit race by splitting exit
Message-Id: <20070125223609.0fbdc3b6.akpm@osdl.org>
In-Reply-To: <20070126052659.GA23250@sergelap.austin.ibm.com>
References: <20070126052659.GA23250@sergelap.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 23:26:59 -0600
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Fix exit race by splitting the nsproxy putting into two pieces.
> First piece reduces the nsproxy refcount.

This broke

	introduce-and-use-get_task_mnt_ns.patch
	nsproxy-externalizes-exit_task_namespaces.patch
	user-namespace-add-the-framework.patch
	user-ns-implement-user-ns-unshare.patch

which I repaired.  Please check the result...
