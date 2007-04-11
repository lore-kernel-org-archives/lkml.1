Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbXDKJxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbXDKJxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXDKJxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:53:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:43043 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751908AbXDKJxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:53:08 -0400
Date: Wed, 11 Apr 2007 02:53:05 -0700
From: Paul Jackson <pj@sgi.com>
To: "Zhao Forrest" <forrest.zhao@gmail.com>
Cc: penberg@cs.helsinki.fi, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Why kmem_cache_free occupy CPU for more than 10 seconds?
Message-Id: <20070411025305.b9131062.pj@sgi.com>
In-Reply-To: <ac8af0be0704110214qdca2ee9t3b44a17341e53730@mail.gmail.com>
References: <ac8af0be0704102317q50fe72b1m9e4825a769a63963@mail.gmail.com>
	<84144f020704102353r7dcc3538u2e34237d3496630e@mail.gmail.com>
	<ac8af0be0704110214qdca2ee9t3b44a17341e53730@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 [<ffffffff80038e33>] put_files_struct+0x6c/0xc3
 [<ffffffff8001543d>] do_exit+0x2d2/0x8b1
 [<ffffffff80047932>] cpuset_exit+0x0/0x6c

I'm confused - which end of ths stack is up?

cpuset_exit doesn't call do_exit, rather it's the other
way around.  But put_files_struct doesn't call do_exit,
rather do_exit calls __exit_files calls put_files_struct.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
