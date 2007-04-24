Return-Path: <linux-kernel-owner+w=401wt.eu-S1161656AbXDXGBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161656AbXDXGBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 02:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161643AbXDXGBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 02:01:13 -0400
Received: from ozlabs.org ([203.10.76.45]:46254 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbXDXGBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 02:01:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17965.40145.647933.480761@cargo.ozlabs.ibm.com>
Date: Tue, 24 Apr 2007 15:59:45 +1000
From: Paul Mackerras <paulus@samba.org>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Transparently handle <.symbol> lookup for kprobes
In-Reply-To: <200704231128.49041.srinivasa@in.ibm.com>
References: <200704231128.49041.srinivasa@in.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srinivasa Ds writes:

> +	} else {							\
> +		char dot_name[KSYM_NAME_LEN+1];				\
> +		dot_name[0] = '.';					\
> +		dot_name[1] = '\0';					\
> +		strncat(dot_name, name, KSYM_NAME_LEN);			\

Assuming the kernel strncat works like the userspace one does, there
is a possibility that dot_name[] won't be properly null-terminated
here.  If strlen(name) >= KSYM_NAME_LEN-1, then strncat will set
dot_name[KSYM_NAME_LEN-1] to something non-null and won't touch
dot_name[KSYM_NAME_LEN].

Paul.
