Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbZGHFhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbZGHFhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZGHFhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:37:02 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35080 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZGHFhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:37:00 -0400
To: Matthias Pfaller <leo@marco.de>
Cc: linux-kernel@vger.kernel.org
References: <4A53728B.9020703@marco.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 07 Jul 2009 22:36:53 -0700
In-Reply-To: <4A53728B.9020703@marco.de> (Matthias Pfaller's message of "Tue\, 07 Jul 2009 18\:06\:35 +0200")
Message-ID: <m1iqi3wxai.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: leo@marco.de, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matthias Pfaller <leo@marco.de>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: Bug in dmi_get_year (causing apic not getting enabled)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthias Pfaller <leo@marco.de> writes:

> Hi,
>
> dmi_get_year extracts the year with:
>
> 	simple_strtoul(s, NULL, 0);
>
> for biosdates in 2008 and 2009 this will return 0 because 8 and 9 are no valid
> octal digits. This will e.g. result in the apic not getting enabled.
> Changing this to
>
> 	simple_strtoul(s, NULL, 10);
>
> should fix the problem.

Only if there is a leading 0....


Eric
