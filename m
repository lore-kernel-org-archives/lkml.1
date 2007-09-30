Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbXI3Jw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbXI3Jw3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 05:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbXI3JwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 05:52:21 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36425 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbXI3JwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 05:52:20 -0400
Date: Sun, 30 Sep 2007 11:53:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, rth@twiddle.net
Subject: Re: another gcc-4.2 compile problem on alpha: gameport
Message-ID: <20070930095346.GA12680@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0709301140060.6443@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0709301140060.6443@math.ut.ee>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2007 at 11:42:20AM +0300, Meelis Roos wrote:
> After I applied the psmouse-base section fix (thanks!), I wuickly ran 
> into another compile problem with gcc-4.2 on alpha:
> 
>   CC [M]  drivers/input/gameport/gameport.o
> drivers/input/gameport/gameport.c:42: error: __ksymtab_gameport_set_name causes a section type conflict
> drivers/input/gameport/gameport.c:41: error: __ksymtab_gameport_cooked_read causes a section type conflict
> 

Maybe it's the same as:
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=31490

I have narrowed it down to the following code snippet. But now the complain are for a different parameter.
But do not have time to persuade it further.
Do you have time to simplify the code snippet and persuade the gcc people?
PS. cc: rth as he are in both camps.

	Sam

The following code result in:
alpha.c:45: error: __param_resolution causes a section type conflict

With gcc:
alpha-unknown-linux-gnu-gcc (GCC) 4.2.1

It was build using Dan Kegel's crosstool so I dunno about the exact configure options used.


gcc (GCC) 4.1.2 20070502 (Red Hat 4.1.2-12) on x86_64 does not issue this error on the same code snippet.
sam-gcc (GCC) 4.2.1 on x86_64 does neither issue same error.
sam-gcc I did built myself with:
configure --prefix=/home/sam/usr/local --program-prefix=sam- --target=alpha-linux





struct kernel_param;


typedef int (*param_set_fn)(const char *val, struct kernel_param *kp);

typedef int (*param_get_fn)(char *buffer, struct kernel_param *kp);

struct kernel_param {
 const char *name;
 unsigned int perm;
 param_set_fn set;
 param_get_fn get;
 void *arg;
};


extern int param_set_uint(const char *val, struct kernel_param *kp);
extern int param_get_uint(char *buffer, struct kernel_param *kp);



static const char __mod_author35[] __attribute__((__used__)) __attribute__((section(".modinfo"),unused)) = "author" "=" "Vojtech Pavlik <vojtech@suse.cz>";
static const char __mod_description36[] __attribute__((__used__)) __attribute__((section(".modinfo"),unused)) = "description" "=" "PS/2 mouse driver";
static const char __mod_license37[] __attribute__((__used__)) __attribute__((section(".modinfo"),unused)) = "license" "=" "GPL";

static unsigned int psmouse_max_proto = 1;
static int psmouse_set_maxproto(const char *val, struct kernel_param *kp) {};
static int psmouse_get_maxproto(char *buffer, struct kernel_param *kp) {};



static inline unsigned int *__check_proto(void) { return(&(psmouse_max_proto)); };
static int __param_perm_check_proto __attribute__((unused)) = (sizeof(char[1 - 2 * !!((0644) < 0 || (0644) > 0777 || ((0644) & 2))]) - 1);
static char __param_str_proto[] = "proto";
static struct kernel_param const __param_proto __attribute__((__used__)) __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) = 
{ __param_str_proto, 0644, psmouse_set_maxproto, psmouse_get_maxproto, &psmouse_max_proto };
static const char __mod_prototype45[] __attribute__((__used__)) __attribute__((section(".modinfo"),unused)) = "parmtype" "=" "proto" ":" "proto_abbrev";
static const char __mod_proto46[] __attribute__((__used__)) __attribute__((section(".modinfo"),unused)) = "parm" "=" "proto" ":" "Highest protocol extension to probe (bare, imps, exps, any). Useful for KVM switches.";

static unsigned int psmouse_resolution = 200;
static inline unsigned int *__check_resolution(void) { return(&(psmouse_resolution)); };
static int __param_perm_check_resolution __attribute__((unused)) = (sizeof(char[1 - 2 * !!((0644) < 0 || (0644) > 0777 || ((0644) & 2))]) - 1);
static char __param_str_resolution[] = "resolution";
static struct kernel_param const __param_resolution __attribute__((__used__)) __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) =
{ __param_str_resolution, 0644, param_set_uint, param_get_uint, &psmouse_resolution };
static const char __mod_resolutiontype49[] __attribute__((__used__)) __attribute__((section(".modinfo"),unused)) = "parmtype" "=" "resolution" ":" "uint";
static const char __mod_resolution50[] __attribute__((__used__)) __attribute__((section(".modinfo"),unused)) = "parm" "=" "resolution" ":" "Resolution, in dpi.";
