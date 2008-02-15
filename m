Return-Path: <linux-kernel-owner+w=401wt.eu-S933952AbYBONqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952AbYBONqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758437AbYBONqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:46:00 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:49849 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558AbYBONp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:45:58 -0500
Date: Fri, 15 Feb 2008 14:45:57 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Priit Laes <plaes@plaes.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: REGRESSION: x86 vDSO: remove vdso-syms.o
In-Reply-To: <20080211232947.4DC10270191@magilla.localdomain>
Message-ID: <Pine.LNX.4.64.0802151444090.30301@fbirervta.pbzchgretzou.qr>
References: <1202769045.10829.12.camel@localhost> <20080211225332.2AE2E270191@magilla.localdomain>
 <20080211231635.GA27673@elte.hu> <20080211232345.A472B270191@magilla.localdomain>
 <20080211232947.4DC10270191@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 11 2008 15:29, Roland McGrath wrote:
>Sam might want to experiment with something like:
>
>	stdout_target = $(1) > $(@D)/.tmp_$(@F) && mv -f $(@D)/.tmp_$(@F) $@
>
>	cmd_foo = $(call stdout_target,blah | sed s/foo/bar/)
>
>to clean up all the places that would benefit from robust treatment for
>output files vs interrupted/erring make runs.

In most cases however, issuing ctrl+c signals make and make will
remove the output file.

Problematic indeed, "temp" could be left when ctrl+c is hit:
foo: bar
	generate-something <bar >temp;
	add-up <temp >foo;

What could work, temp being removed on ^C:
temp: bar
	generate-something <bar >temp;
foo: temp
	add-up <temp >foo;
