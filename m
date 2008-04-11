Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbYDKNtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbYDKNtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 09:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758503AbYDKNtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 09:49:08 -0400
Received: from smtp-out.google.com ([216.239.33.17]:8225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869AbYDKNtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 09:49:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=TPWIb985vi58YoIAzGVHkUQYNmDV1RbRBX0K4YI4ppOfzyiOgy4j2aiJXyObUl1Og
	fm9G5m/VFLV6OXPMsfHRQ==
Message-ID: <d43160c70804110649q1b099b02n835f90c5651f3073@mail.gmail.com>
Date: Fri, 11 Apr 2008 09:49:00 -0400
From: "Ross Biro" <rossb@google.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rossb@google.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] MM: Make Page Tables Relocatable -- conditional flush
In-Reply-To: <20080410172603.98224DCA40@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080410172603.98224DCA40@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 1:26 PM, Ross Biro <rossb@google.com> wrote:
>  rcu cleanup.  There still appears to be a race, but it looks like it's
>  in the rcu code.  If I reduce the migration code to
>
>  down_interruptible()
>  synchronize_rcu()
>  up()
>
>  I still get a crash about once every 1-2 million times through the
>  loop.  If the race is in my code, it's something stupid.  Otherwise
>  it's elsewhere and my code won't make things anyworse.

This race appears to have been fixed between 2.6.25rc5-mm1 and
2.6.25rc8-mm1.  I've been running the later over night and have over 7
million iterations with out a crash.

    Ross
