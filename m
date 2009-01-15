Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbZAOHZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbZAOHZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:25:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191AbZAOHZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:25:01 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:23757 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753635AbZAOHZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:25:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OzYZ5SuheTw31xLEGtOKK+3CQgSJ8OiajG4SqAzTKGLrzBMFy26y8JlyzKoAGkd4Yicqj3Ydy9NLQ+a9/5L3nbgTEFHj0nvYh3B9xQA6Py++oBb9j3p6zPzCnC4WvQJJ/JD3bqPBno8OP7GyCTqyMGmqzeu6Ak581vFyAEXxqZY=  ;
X-YMail-OSG: uA2iBvwVM1kcjErp8PYlhMCTIwcArVDj5kE.6Zs__y5d4EU1ibnqCM_LLhyoPslJ7o5Cz912V5GUxnRLt5wsV11AsLdUQKSH4DcAxkGtrz15b5BPMZCd32dZL5yYzknZ625Nh3t9xx45vybcBwSnUlXMkcGKpvX5RbQZ8L0GZA2r1PcGy2h7Dn.GL8aI6g--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Larry Woodman <lwoodman@redhat.com>
Subject: Re: Question about do_wp_page() and lock_page()
Date: Thu, 15 Jan 2009 18:01:23 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org
References: <1231968908.3198.17.camel@dhcp-100-19-198.bos.redhat.com>
In-Reply-To: <1231968908.3198.17.camel@dhcp-100-19-198.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151801.23580.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009 08:35:08 Larry Woodman wrote:
> Why is it safe for do_wp_page() to call cow_user_page() without locking
> the old_page first?  If a Direct IO read is outstanding on the old_page
> or its the buffer to the file_read_actor() cant its contents change
> during the COW fault?  Is this not a problem?

Direct IO doesn't lock the pages either.

There has simply never been any synchronisation here (by design: see
MADV_DONTFORK/MADV_DOFORK/VM_DONTCOPY etc).

This is one thing which Andrea had been trying to improve. If it can
be done without introducing nasty overheads, then yes it would be
nice to improve COW vs DIO semantics.

