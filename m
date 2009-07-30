Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbZG3ATk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbZG3ATk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 20:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755287AbZG3ATk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 20:19:40 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17010 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266AbZG3ATj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 20:19:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=vpd7L3nwoU5wbNls+pRGpePP25aWtlrUQKIPxmwg/whpkPgLfv/pP7IwmpKDy8e6p
	5MbZ4KAdfEEznqstkU7Pw==
MIME-Version: 1.0
In-Reply-To: <20090729114322.GA9335@localhost>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com>
	 <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com>
	 <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com>
	 <20090729114322.GA9335@localhost>
Date: Wed, 29 Jul 2009 17:19:34 -0700
Message-ID: <33307c790907291719r2caf7914xb543877464ba6fc2@mail.gmail.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
From: Martin Bligh <mbligh@google.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chad Talbott <ctalbott@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Michael Rubin <mrubin@google.com>,
       Andrew Morton <akpm@google.com>, sandeen@redhat.com,
       Michael Davidson <md@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BTW, can you explain this code at the bottom of generic_sync_sb_inodes
for me?

                if (wbc->nr_to_write <= 0) {
                        wbc->more_io = 1;
                        break;
                }

I don't understand why we are setting more_io here? AFAICS, more_io
means there's more stuff to write ... I would think we'd set this if
nr_to_write was > 0 ?

Or just have the section below brought up above this
break check and do:

if (!list_empty(&sb->s_more_io) || !list_empty(&sb->s_io))
        wbc->more_io = 1;

Am I just misunderstanding the intent of more_io ?
