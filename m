Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbXH1GWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbXH1GWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbXH1GWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:22:08 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:57972 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbXH1GWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jrHj0FtuRsfn5KKX3lLKXa8VsPGBrdJhqtwJSggspCyCKlzZL+kYrZ+ukw5UTnA0eyGi8zZ1nPLRPcmeR94jr6w/MiMHQ0EkkYvjxbx6eSpXCOED+ZNa+7aLsKTa/yhmWdEEHR2xznMEyEGihvvfnQrha2T63aX5eIjqjLoY/Rc=
Message-ID: <24c1515f0708272322h2875ea28k7a28b8651513132a@mail.gmail.com>
Date: Tue, 28 Aug 2007 09:22:04 +0300
From: "Janne Karhunen" <janne.karhunen@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: NFSv3 lock recovery
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Brief question about NFSv3 lock recovery to those who might
know - does Linux implementation (or NLM/NSM protocol)
properly support the case in which client and server state
change simultaneously?

Reason I'm asking is that this very case is occasionally giving
me stale locks. Given that NFSv3 server crashes it's possible
that client 'rooting' from it crashes as well. Now, once the
server comes back up it tries to notify the client that just
crashed. Hardly surprisingly, this notification doesn't go
anywhere and server discards the notification/client. And once
the client starts to boot again it tries to notify the server which
instantly whines about SM_NOTIFY when no-one is being
monitored. Thus, whole notification cycle is busted and lock
states go haywire :/. Is this even supposed to work?



-- 
// Janne
