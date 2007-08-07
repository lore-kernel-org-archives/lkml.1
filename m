Return-Path: <linux-kernel-owner+w=401wt.eu-S1765459AbXHGAqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765459AbXHGAqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 20:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763046AbXHGAqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 20:46:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:36190 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184AbXHGAqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 20:46:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=lWjRkwnzm+QriLfI3woPw+UsS5gcXbDKwUnIW8Sh/kM1+3NYKn0N551ARK1y00zlp
	gOWCSO6TLheKdD4wtBTWw==
Message-ID: <65dd6fd50708061746p2a460fe5p24f1068c36ef5c40@mail.gmail.com>
Date: Mon, 6 Aug 2007 17:46:28 -0700
From: "Ollie Wild" <aaw@google.com>
To: mtk-manpages@gmx.net
Subject: execve manpage changes
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <65dd6fd50708061738pabd807tb26d38641cc5e7e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <65dd6fd50708061738pabd807tb26d38641cc5e7e2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael,

Per our previous discussion, here are the updates to the execve(2)
manpage resulting from the variable length argument support patch in
linux-2.6.23-rc1.  The execve API is unmodified.  However, the
following should be noted in the "Notes" section.

Prior to linux-2.6.23, the memory used to store the environment and
argument list strings was limited to 32 (MAX_ARG_PAGES) pages.  On
most architectures, the page size is 4kB, leading to a maximum size of
128kB.

In linux-2.6.23 and later, most architectures support a size limit
derived from the current RLIMIT_STACK setting (see getrlimit(2)).  For
these architectures, the total size is limited to 1/4 the allowed
stack size, the limit per string is 32 pages (MAX_ARG_STRLEN), and the
maximum number of strings is 0x7FFFFFFF.  Architectures with no memory
management unit are excepted: they maintain the pre-2.6.23 limit.

Ollie
