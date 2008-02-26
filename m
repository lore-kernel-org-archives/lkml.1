Return-Path: <linux-kernel-owner+w=401wt.eu-S1761069AbYBZAFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761069AbYBZAFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:05:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYBZAFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:05:04 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1386 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbYBZAFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:05:02 -0500
Subject: RE: printk_ratelimit and net_ratelimit conflict and tunable
	behavior
From: Joe Perches <joe@perches.com>
To: Hawkes Steve-FSH016 <Steve.Hawkes@motorola.com>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <7BFDACCD6948EF4D8FE8F4888A91596A016371FE@tx14exm60.ds.mot.com>
References: <7BFDACCD6948EF4D8FE8F4888A91596A016371E8@tx14exm60.ds.mot.com>
	 <20080220.223219.165157596.davem@davemloft.net>
	 <1203577246.7181.241.camel@localhost>
	 <7BFDACCD6948EF4D8FE8F4888A91596A016371FA@tx14exm60.ds.mot.com>
	 <1203970417.19319.287.camel@localhost>
	 <7BFDACCD6948EF4D8FE8F4888A91596A016371FE@tx14exm60.ds.mot.com>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 16:04:38 -0800
Message-Id: <1203984278.19319.312.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-25 at 17:49 -0600, Hawkes Steve-FSH016 wrote:
> Are you saying the few lines of code to handle changes to the tunables
> aren't worth keeping?

Yes.

I think the tunables, if needed at all, should be set by modifying
the struct and the call might as well be:
	
bool __printk_ratelimit(struct printk_ratelimit_state *state)

Another quibble is not directed to your change because it's
preexisting but "tok" isn't a good name and may not even need
to be in the structure.  It does save a multiply though.

I think that anything that attempts a printk is slow path
so it doesn't matter much though.

