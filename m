Return-Path: <linux-kernel-owner+w=401wt.eu-S1752362AbXKVMGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbXKVMGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 07:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbXKVMGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 07:06:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60787 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXKVMGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 07:06:14 -0500
Date: Thu, 22 Nov 2007 13:06:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stewart Smith <stewart@mysql.com>
Cc: David Chinner <dgc@sgi.com>, Andi Kleen <andi@firstfloor.org>,
       xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071122120611.GA3573@one.firstfloor.org>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com> <1195702123.8369.78.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195702123.8369.78.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> FWIW from a "real time" database POV this seems to make sense to me...
> in fact, we probably rely on filesystem metadata way too much
> (historically it's just "worked".... although we do seem to get issues
> on ext3).

For that case you really would need priority inheritance: any metadata
IO on behalf or blocking a process needs to use the process' block IO 
priority.

David's change just fixes a limited set of cases, but breaks others.

-Andi
